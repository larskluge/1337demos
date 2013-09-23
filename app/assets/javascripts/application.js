/* DO NOT MODIFY. This file was compiled Fri, 29 Apr 2011 19:47:45 GMT from
 * /Users/viper/projects/1337demos.com/1337demos-platform/app/coffeescripts/application.coffee
 */

(function() {
  var localStorageSupport;
  localStorageSupport = function() {
    try {
      return window.localStorage != null;
    } catch (error) {
      return false;
    }
  };
  $(function() {
    var name, pass;
    if ((typeof Cookie != "undefined" && Cookie !== null) && Cookie.exists('player')) {
      Cookie.erase('player');
    }
    if (localStorageSupport()) {
      name = localStorage['1337demos.player.name'];
      pass = localStorage['1337demos.player.pass'];
      if (name) {
        $('[data-player=name]').val(name);
      }
      if (pass) {
        $('[data-player=pass]').val(pass);
      }
      $('[data-player=name]').blur(function(event) {
        return localStorage['1337demos.player.name'] = $(this).val();
      });
      return $('[data-player=pass]').blur(function(event) {
        return localStorage['1337demos.player.pass'] = $(this).val();
      });
    }
  });
}).call(this);
