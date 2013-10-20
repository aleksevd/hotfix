jQuery ->
  initialize_editor = ->
    file_textarea = $("#project_file_content")[0]
    console.log file_textarea
    if file_textarea?
      CodeMirror.fromTextArea(file_textarea, tabSize: 2, lineNumbers: true)
      
  initialize_editor()    
  $(document).on('page:load', initialize_editor)