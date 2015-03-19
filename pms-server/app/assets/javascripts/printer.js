var printer = {
    url: function (code) {
        return $('#print-server-hidden').val() + code + '/' + this.id();
    },
    print: function (code) {
        if (this.id() && confirm('确认打印？')) {
            show_handle_dialog();
            var url = this.url(code);
            $.ajax({
                url: url,
                type: 'get',
                dataType: 'json',
                timeout: 10000,
                crossDomain: true,
                success: function (data) {
                    if (data) {
                        sweetAlert(data.content);
                    } else {
                        sweetAlert("Oops...", "打印失败，请开启打印服务器或重新配置", "error");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest.status);
                    if (XMLHttpRequest.status == 500) {
                        sweetAlert("Oops...", "打印打印服务程序内部错误，请联系系统管理员或服务商", "error");
                    } else {
                        sweetAlert("Oops...", "无法连接打印服务器，请开启打印服务器或重新配置 或 打印被取消", "error");
                    }
                }
            }).always(function () {
                    hide_handle_dialog();
            });
        }
    },
    id: null
};

function print_blue() {
    printer.print('P001');
}
function print_white() {
    printer.print('P002');
}

// init file
$(document).ready(function(){
    $('body').on('click',".print",function () {
        var target = $(this);
        printer.id = function(){
            return target.attr("id");
        };
        var type = $(this).attr("kanban_type");
        if(type == 0){
            printer.print("POO2");
        }else{
            printer.print("P001");
        }
    })
})