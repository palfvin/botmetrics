
window.set_position = (ui, de_id) -> 
  $.ajax
    url: "/dashboard_elements/#{de_id}"
    type: "PUT"
    data: 
      dashboard_element:
        top: ui.position.top
        left: ui.position.left
    dataType: 'json'
    success: (data) -> alert 'Load was performed'


window.set_size = (ui, de_id) -> 
  $.ajax
    url: "/dashboard_elements/#{de_id}"
    type: "PUT"
    data: 
      dashboard_element:
        width: ui.size.width
        height: ui.size.height
    dataType: 'json'
    success: (data) -> alert 'Load was performed'
