function adapt_event(e) {
    return e ? e : window.event;
}


function is_auto_submit_input_event(event, element, can_not_blank) {
    var e = adapt_event(event);
    can_not_blank = can_not_blank === undefined ? true : can_not_blank;
    // 13: ENTER
    // 9:  TAB
    if ((e.type == 'keyup' && ( e.keyCode == 13 || e.keyCode == 9)) || e.type == 'blur') {
        return can_not_blank ? ($(element).val() != '') : true;
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

function move_order_item() {
    var items = get_items();
    console.log(items);
    if (items.length == 0) {
        swal('请选择生产任务');
        return;
    }
    var to_machine = $('#to-machine').val();
    console.log(to_machine);
    if (to_machine == '') {
        swal('请选择目标机器');
        return;
    }
    $.post('/production_order_items/move', {machine: to_machine, items: items}, function (data) {
        if (data.result) {
            swal('移动成功');
            window.location.reload();
        } else {
            swal('移动失败，请联系管理员');
        }
    });
}

function check_all_box(box_class) {
    var checked = $(this).attr('current-state') == '1';
    console.log(checked);
    if (checked) {
        $(this).val('全选本页');
        $(this).attr('current-state', '0');
        $('input:checkbox').removeAttr('checked');
    } else {
        $(this).val('取消全选本页');
        $(this).attr('current-state', '1');
        $('input:checkbox').prop('checked', true);
    }

}

function change_state(state) {
    if (confirm('确定执行？？？')) {
        var items = get_items();
        console.log(items);
        if (items.length == 0) {
            swal('请选择生产任务');
            return;
        }
        $.post('/production_order_items/change_state', {items: items, state: state}, function (data) {
            if (data.result) {
                swal('执行成功！');
                window.location.reload();
            } else {
                swal('执行失败，请联系管理员');
            }
        });

    }
}

function get_items() {
    var items = [];
    $.each($('.order-item-check:checked'), function (i, item) {
        console.log($(item).attr('item'));
        items.push($(item).attr('item'));
    });
    return items;
}

function set_urgent() {
    if (confirm('确定执行？？？')) {
        var items = get_items();
        console.log(items);
        if (items.length == 0) {
            swal('请选择生产任务');
            return;
        }
        $.post('/production_order_items/set_urgent', {items: items}, function (data) {
            if (data.result) {
                swal('执行成功！');
                window.location.reload();
            } else {
                swal('执行失败，请联系管理员');
            }
        });

    }
}

function delete_item(url) {
    if (confirm('确定删除？？？')) {
        var items = get_items();
        console.log(items);
        if (items.length == 0) {
            swal('请选择要删除的数据');
            return;
        }
        $.ajax({
            type: 'delete',
            url: url,
            data: items,
            success: function (data) {
                if (data.result) {
                    swal('删除成功！');
                    window.location.reload();
                } else {
                    swal('删除失败，请联系管理员');
                }
            }
        });

    }
}