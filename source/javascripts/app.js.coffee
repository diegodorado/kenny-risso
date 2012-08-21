#store vars to buster speed
$home = null
$homeLogo = null
$homeLangSwitch = null
$slides = null
$contact = null
$window = null
aspectRatio = null


img_url= (selector)->
  $el = $(selector)
  if $el.is('img')
    $el.attr 'src'
  else
    $el.css('backgroundImage').replace(/^url\(["']?/, '').replace(/["']?\)$/, '')


img= (src) ->
  #IE doesnt fire the load event if image is cached
  if $.browser.msie
    src += "?" + new Date().getTime() 
  i = $("<img />", {src:src})
  i
  

logoLoaded= (e) ->
  $homeLangSwitch.fadeIn 2000
  $homeLogo.fadeIn 2000, ()->
    startSlide()

windowScroll= (e) ->
  ws = $window.scrollTop()
  fadeAt = $home.height()/3 #fade at 1/3 screen

  $homeLogo.css
    'bottom' : (163 + ws/1)+"px"
    'opacity' : 1-(ws/fadeAt)

  $homeLangSwitch.css
    'opacity' : 1-(ws/fadeAt)

startSlide= () ->

  $slides = $('.slide')
  index = Math.floor(Math.random() * $slides.size() ) - 1
  $first = $slides.eq(index) #first slide should be random
  $first.addClass('next') #its the next without prev

  i = img(img_url($first))
  $(i).bind 'load', () ->
    #set aspect ratio global variable
    #asumes all images have the same AR
    aspectRatio = @width/@height
    
    #bind window resize and trigger it once    
    $window.resize(->
      wh = $window.height()
      ww = $window.width()
      $home.height  wh
      $contact.css 'top', wh
      $home.toggleClass "tall", (ww/wh) < aspectRatio
      top = (wh - ww/aspectRatio)/2
      top = 0 if top > 0
      left = (ww - wh*aspectRatio)/2
      left = 0 if left > 0
      $home.find('.slides').css
        top: top
        left: left
    ).trigger "resize"
    

    setTimeout((()->$first.css('opacity', 1)), 250)  #give jquery time to apply class
    $('.curtain').fadeIn(1000)
    setTimeout(slide, 4000)  #start slides


slide=()->
  $prev = $('.slide.next') #prev was next earlier

  $next = $prev.next() #next is above prev
  if $next.size() is 0
    $next = $('.slide').first() #if not, then cycle

  if $prev.prop('complete') and $next.prop('complete')
    $('.slide.prev').css('opacity', 0).removeClass('prev') #prev has changed.. will be set now
    $prev.addClass('prev').removeClass('next') #no more next, now it it prev
    $next.addClass('next') #give next his proper class

    setTimeout((()->$next.css('opacity', 1)), 250)  #give jquery time to apply class
    setTimeout(slide, 4000)
  else
    setTimeout(slide, 200) #retry





$ ->

  $home = $('section.home')
  $homeLogo = $('section.home .logo')
  $homeLangSwitch = $('section.home .lang-switch')
  $slides = $('section.home .slides')
  $contact = $('section.contact')
  $window = $(window)
  $('body').scrollTop(0)

  i = img(img_url('section.home .logo h2 a'))
  $(i).bind 'load', logoLoaded
  
  $window.scroll windowScroll



  
