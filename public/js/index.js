$(function(){
    $('#btn_upload').click(
        function(){
            var name = $('#upload_name').val();
            if(name.length < 1) name = 'share';
            location.href = app_root+'/'+name+'/upload';
        }
    );
});
