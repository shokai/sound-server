$(
    function(){
        $('#speech')[0].addEventListener(
            'webkitspeechchange',
            function(){
                var speech = $('#speech').val();
                $.ajax(
                    {
                        url : app_root+'/'+user+'/upload_text',
                        data : {
                            text : speech, no_redirect : true
                        },
                        success : function(res){
                            console.log(res);
                            location.href = res;
                        },
                        error : function(e){
                            console.log(e);
                        },
                        type : 'POST',
                        dataType : 'text'
                    }
                );
            }
        );
    }
);