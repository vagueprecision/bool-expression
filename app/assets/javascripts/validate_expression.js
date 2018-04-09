$( document ).ready(function() {
    var delayTimer;
    $('#expression_expression').keyup(function(){
        clearTimeout(delayTimer);
        $("#eval").html("");
        var expression = $(this).val().trim();
        if (expression === "") {
            $("#valid").html("");
        }
        else
        {
            delayTimer = setTimeout(function() {
                $.ajax({
                    type: 'POST',
                    url: window.location.protocol + '//' + window.location.host + '/expressions/validate',
                    data: { 'expression': expression },
                    success: function(resp) {
                        if (resp.valid) {
                            $("#valid").html("Valid!");
                            $("#valid").removeClass();
                            $("#valid").addClass('positive');
                            $("#sample_eval").removeClass('disabled');
                        }
                        else {
                            $("#valid").html(resp.errorMessage);
                            $("#valid").removeClass();
                            $("#valid").addClass('negative');
                            $("#sample_eval").addClass('disabled');
                        }
                    }
                });
            }, 1000);
        }
    });

    $('#sample_eval').click(function(){
        var expression = $('#expression_expression').val().trim();
        if (expression !== "") {
            $.ajax({
                type: 'POST',
                url: window.location.protocol + '//' + window.location.host + '/expressions/evaluate',
                data: { 'expression': expression },
                success: function(resp) {
                    var cssclass = resp.result ? 'positive' : 'negative';
                    $("#eval").html("This expression evaluates to <b><span class='" + cssclass + "'>" + resp.result + "</span></b>");
                }
            });
        }
    });
});
