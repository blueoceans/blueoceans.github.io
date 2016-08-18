$jmpress = undefined

jmpress_init = ->
  $ ->
    $.jmpress "template", "pic1",
      scale: 0.2
      secondary:
        "": "siblings"
        scale: 1

    $.jmpress "template", "pics1",
      children: [
        {
          x: -250
          y: 50
          template: "pic1"
          secondary:
            x: 0
            y: 1000
        }
        {
          x: 0
          y: 50
          template: "pic1"
          secondary:
            x: 0
            y: 2000
        }
        {
          x: 250
          y: 50
          template: "pic1"
          secondary:
            x: 1000
            y: 2000
        }
        {
          x: -250
          y: 200
          template: "pic1"
          secondary:
            x: 1000
            y: 3000
        }
        {
          x: 0
          y: 200
          template: "pic1"
          secondary:
            x: 0
            y: 3000
        }
        {
          x: 250
          y: 200
          template: "pic1"
          secondary:
            x: 0
            y: 4000
        }
        {
          x: -250
          y: 350
          template: "pic1"
          secondary:
            x: -1000
            y: 4000
        }
        {
          x: 0
          y: 350
          template: "pic1"
          secondary:
            x: -1000
            y: 3000
        }
        {
          x: 250
          y: 350
          template: "pic1"
          secondary:
            x: -1000
            y: 2000
        }
      ]

    $.jmpress "template", "pic2",
      scale: 0.2
      secondary:
        "": "self"
        scale: 1
        x: 0
        y: 500

    $.jmpress "template", "pics2",
      children: (idx) ->
        x: 50 - idx * 10
        y: 100 - idx * 10
        z: 10 - idx
        template: "pic2"

    $.jmpress "template", "pics3",
      children: (idx) ->
        r: 250
        phi: idx * 40
        rotateY: idx * 40
        scale: 0.2
        rotateX: 90

    $.jmpress "template", "main",
      children: [
        {
          x: 1000
          rotate: 0
        }
        {
          x: 2000
          rotate: 0
        }
        {
          x: 3000
          rotate: 0
        }
      ]

    $jmpress = $("article")

    $jmpress.jmpress
      stepSelector: "section"
      viewPort:
        height: 500
        width: 1000
        maxScale: 1

    auto_play()
    return

  auto_play = ->
    $jmpress.jmpress("next")
    setTimeout auto_play, 10000
    return

  return
