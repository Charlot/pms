function adapt_event(e) {
    return e ? e : window.event;
}


function is_auto_validate_input_event(event, element, can_not_blank) {
    var e = adapt_event(event);
    can_not_blank = can_not_blank === undefined ? true : can_not_blank;
    // 13: ENTER
    // 9:  TAB
    if ((e.type == 'keyup' && ( e.keyCode == 13 || e.keyCode == 9)) || e.type == 'blur') {
        return can_not_blank && ($(element).val() != '');
    }
    return false;
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