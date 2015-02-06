function adapt_event(e) {
    return e ? e : window.event;
}

function load_process_template_partial(code, callback) {
    $.get('/process_templates/template', {code: code}, function (template) {
        callback(template);
    });
}

function validate_custom_field_part(id, args, callback) {
    $.post('/custom_fields/validate', {id: id, args: args}, function (data) {
        callback(data);
    });
}