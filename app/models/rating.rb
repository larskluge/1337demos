class Rating < ActiveRecord::Base

	belongs_to :rateable, :polymorphic => true

	@@range = 0..5
	cattr_reader :range



	def rate(amount, ip)
		amount = amount.to_i
		raise(ArgumentError, "Amount #{amount} out of range #{self.range}") unless self.range.include?(amount)
		raise(StandardError, "IP #{ip} Already voted") if last_ip == ip && Rails.env == 'production'

		self.count += 1
		self.total += amount
		self.average = total.to_f / count
		self.last_ip = ip

		save!
	end

	def key=(key)
		raise(ArgumentError, 'key not of class String or Symbol') unless [String, Symbol].include?(key.class)

		#@key = key.to_s
		write_attribute(:key, key.to_s)
	end

	def rated?
		self.count > 0
	end

end

