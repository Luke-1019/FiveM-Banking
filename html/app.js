$(function() {
    function display(bool) {
        if (bool) {
            $(".frame-div1").show();
        } else {
            $(".frame-div1").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        } else if(item.type === "balanceHUD") {
            const fullcash = item.fullcash + "$";
            const fullbalance = item.balance + "$";
            $('.bank-amount').html(fullbalance);
            $('.cash-amount').html(fullcash);
        }

        if (item.status == true) {
            display(true)
        } else if (item.status == false) {
            display(false)
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://banking/exit', JSON.stringify({}));
            return
        }
    };

    $('.rectangle-input').click(function(){
        $.post('http://banking/deposit', JSON.stringify({
            amount: $(".rectangle-button").val()
        }));
    })

    $('.rectangle-button1').click(function(){
        $.post('http://banking/withdrawl', JSON.stringify({
            amountw: $(".rectangle-div18").val()
        }));
    })

    $('.rectangle-div19').click(function(){
        $.post('http://banking/transfer', JSON.stringify({
            amountt: $('.rectangle-button2').val(),
            target: $('.rectangle-button3').val()
        }));
    })
});

