$(document).ready(function(){
  // add on logic
  // ============
  $('.add-on :checkbox').click(function () {
    if ($(this).attr('checked')) {
      $(this).parents('.add-on').addClass('active')
      $(this).parents('.add-on').next().removeClass('disabled').removeAttr('disabled').focus()
    } else {
      $(this).parents('.add-on').removeClass('active')
      $(this).parents('.add-on').next().addClass('disabled').attr('disabled', 'disabled')
    }
  })

}); 