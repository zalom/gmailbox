$(document).ready(function(){
  $('button.reply-btn').on('click',function(e) {
    e.preventDefault();
    window.location = "http://localhost:3000/mailbox/reply.html";
  });
  $('button#back-btn, button#register-back-btn').on('click', function(e) {
    e.preventDefault();
    window.location = "http://localhost:3000/mailbox/login.html";
  });

  $('button#login-btn, button#register-submit-btn, button#forgot-submit').on('click', function(e) {
    e.preventDefault();
    window.location = "http://localhost:3000/mailbox/inbox.html";
  });
  $('button#btn-send, button#btn-discard').on('click',function(e) {
    e.preventDefault();
    window.location = "http://localhost:3000/mailbox/inbox.html";
  });
  $('button#btn-draft').on('click',function(e) {
    e.preventDefault();
    window.location = "http://localhost:3000/mailbox/draft.html";
  });

  $("a.thread-link").click(function(){
    $('div.thread').load('thread.html');
     //alert("Thanks for visiting!");
  });

});
