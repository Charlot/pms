function show_handle_dialog() {
    document.getElementById('handle-dialog-modal').style.display = 'block';
    document.getElementById('dialog-overlay').style.display = 'block';
}

function hide_handle_dialog() {
    document.getElementById('handle-dialog-modal').style.display = 'none';
    document.getElementById('dialog-overlay').style.display = 'none';
}

function data_upload(idStr, format, callback) {
    var valid = true;
    var reg = /(\.|\/)(josn|csv|tff|xls|xlsx)$/i;
    if (format != null) {
        if (format != false) {
            reg = new RegExp('(\.|\/)(' + format + ')$', 'i');
        } else {
            reg = null;
        }
    }

    $(idStr).fileupload({
        singleFileUploads: false,
        acceptFileTypes: /(\.|\/)(json|csv|tff|xls|xlsx)$/i,
        dataType: 'json',
        change: function (e, data) {
            valid = true;
            $(idStr + '-preview').html('');
            $.each(data.files, function (index, file) {
                var msg = "上传中 ... ...";
                if (reg) {
                    if (!reg.test(file.name)) {
                        msg = '格式错误';
                        swal(msg);
                        valid = false;
                        return;
                    }
                    show_handle_dialog();
                }
                $(idStr + '-preview').show().append("<span>文件：" + file.name + "</span><br/><span info>处理中....</span>");
            });
        },
        add: function (e, data) {
            if (valid)
                if (data.submit != null)
                    data.submit();
        },
        beforeSend: function (xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: function (data) {
            if (callback) {
                callback(data);
            } else {
                hide_handle_dialog();
                $(idStr + '-preview > span[info]').html("处理：" + data.content);
            }
        },
        done: function (e, data) {
        }
    });
}