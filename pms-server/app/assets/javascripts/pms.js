function adapt_event(e) {
    return e ? e : window.event;
}

function load_process_template_partial(nr, callback) {
    $.get('/process_templates/template', {nr: nr}, function (template) {
        callback(template);
    });
}