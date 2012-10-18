//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.23.custom.min
//= require chosen.jquery
//= require jquery.jeditable
//= require jquery.markitup
//= require sets/markdown/set

(function($){

  $.fn.outerHTML = function() {
    return $(this).clone().wrap('<p></p>').parent().html();
  }

  $(document).ready(function(){

    $('textarea.markdown').markItUp(mySettings);
    $('select.chosen').chosen();


    $('.sortable').sortable({
      update: function(e, ui){
        var $target        = $(e.target),
            orderedItems   = {},
            resourceURL    = $target.attr('data-resource'),
            childTag       = $target.children()[0].nodeName.toLowerCase(),
            primaryLabel   = $target.attr('data-primary-label'),
            secondaryLabel = $target.attr('data-secondary-label');

        $(childTag, $target).each(function(index, element){
          var objectId = $(element).attr('data-id');
          orderedItems[objectId] = (index + 1);
        });
        $.ajax({
          type: 'POST',
          url: resourceURL,
          data: {collection: orderedItems},
          success: function(data, statusCode){
            if (childTag == 'li'){
              $target.effect('highlight', {}, 1500);
            } else {
              $target.parents('fieldset').effect('highlight', {}, 1500);
            }
            if (primaryLabel !== undefined){
              $('td.label', $target).text(secondaryLabel);        // This could be implemented better
              $('td.label', $target).first().text(primaryLabel);  //
            }
          }
        });
      }
    });




    $("div.content").hide();

    $("a.heading").click(function(){
        $(this).siblings(".intro").toggle()
        $(this).next("div.content").slideToggle(300);
        $(this).text($(this).text() == '[Read the complete essay]' ? '[Hide essay]' : '[Read the complete essay]');
    });

  });
})(jQuery);
