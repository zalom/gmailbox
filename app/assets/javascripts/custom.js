$(document).on('turbolinks:load', function() {

  $('ul.inbox-nav').on('click', "li", function(){
    localStorage.setItem('containerId', $(this).attr('id'));
    localStorage.setItem('containerClass', $(this).attr('class'));
  });
  //removeOtherActiveClasses();
  toggleActiveClass();
});

function toggleActiveClass(){
  var lsContainerId = localStorage.getItem('containerId');
  var lsContainerClass = localStorage.getItem('containerClass');
  if(lsContainerId){
    console.log(lsContainerId);
    var currentElement = $('ul.inbox-nav').find('li#'+lsContainerId);
    if(currentElement.hasClass('inactive')){
      currentElement.addClass('active');
      currentElement.removeClass('inactive');
      console.log("active added");
    }
    else{
      currentElement.removeClass('active');
      currentElement.addClass('inactive');
      console.log("active removed");
    }
  }

}

function removeOtherActiveClasses(){
  $('ul.inbox-nav li').removeClass('active');
}
