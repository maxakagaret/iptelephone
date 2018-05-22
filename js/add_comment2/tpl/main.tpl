{var LINKS = <link type="text/css" rel="stylesheet" href="{IMG}add_comment.css" />}

<script type="text/javascript" src="{JS}autogrow.jquery.js"></script>
<script type="text/javascript">
    <!--
    $(document).ready(function() {
        var settings = JSON.parse('{PLUGIN-SETTINGS}' || null);

        var handler = function(json) {
            /* response handler here */
            console.log(json);
        }

        function register_plugin(collector) {
            var plugin = {
                "name": collector['name'],
                "collector": collector,
                "handler": handler,
                "load": (check_option('{OPTIONS}', 'sync') ? 'sync' : 'async')
            }
            register_handler(plugin);
            /* register events example */
            register_event('add-comment', export_add_comment, collector['name']); 
        }

        function dbinit() {
            var collector = {
                "name": "{PLUGIN-NAME}.{ID}",
                "path": "{PLUGIN-DIR}",
                "folder": "{FOLDER}",
                "page": "{PAGE}"
            }

            register_plugin(collector);
           
            if (!check_option('{OPTIONS}', 'sync')) {
                $.post('{AJAX}dbinit.php', collector, handler, 'html');
            }

            build();

	    $('.{PLUGIN-NAME}-{ID} textarea').autogrow();
        }

        function build() {
            let container = $('.{PLUGIN-NAME}-{ID} .comment-container'),
            
            form = $('.{PLUGIN-NAME}-{ID} .comment-container form');
            form.innerWidth(container.innerWidth());
            form.css('left', container.offset().left);
        }

        $('.{PLUGIN-NAME}-{ID} .comment-container .comment-label').live('click', function() {
            $(this).closest('.comment-container').find('.comment-text').focus();
        });

        $('.{PLUGIN-NAME}-{ID} .comment-container .comment-text').live('focus',function() {
            if(!$(this).hasClass('expanded')) {
                $(this).addClass('expanded');
                $(this).closest('.comment-container').find('.buttons-box').slideDown();
            }
        });

        $('.{PLUGIN-NAME}-{ID} .comment-container .buttons-box .btn-cancel').live('click',function() {
            let container = $(this).closest('.comment-container'),
            
            button_box = $(this).closest('.buttons-box');
            container.find('.comment-text').removeClass('expanded').val('');
            container.find('.buttons-box').slideUp();
            button_box.find('.comment-filename').text('');
            button_box.find('.comment-file').val('');
        });

        $('.{PLUGIN-NAME}-{ID} .comment-container .buttons-box .btn-file').live('click',function() {
            $(this).closest('.buttons-box').find('.comment-file').click();
        });

        $('.{PLUGIN-NAME}-{ID} .comment-container .buttons-box .comment-file').live('change',function() {
            let file_split_name = $(this).val().split('\\'),
            
            file_name = file_split_name[file_split_name.length-1];
            $(this).closest('.buttons-box').find('.comment-filename').text(file_name);
        });

        $('.{PLUGIN-NAME}-{ID} .comment-container .buttons-box .btn-send').live('click',function() {
            let container = $(this).closest('.comment-container'),
            
            button_box = $(this).closest('.buttons-box');
            
            ssb_fire('add-comment', {
                'text': container.find('.comment-text').val(),
                'file': container.find('.comment-file').val(),
            });
            
            container.find('.comment-text').removeClass('expanded').val('');
            container.find('.buttons-box').slideUp();
            button_box.find('.comment-filename').text('');
            button_box.find('.comment-file').val('');
        });

        function export_add_comment(data) {
            console.log('save-field: %o',data);
        }
        
        dbinit();
    });
    -->
</script>

<div class="{PLUGIN-NAME}-{ID}" data-plugin-name="{PLUGIN-NAME}.{ID}">
    <div class="comment-container">
        <form method="post">
            <div class="row">
                <div class="col-xs-12">
                    <textarea class="comment-text" placeholder="Добавить комментарий ..."></textarea>
                </div>
            </div>
            <div class="row buttons-box">
                <div class="col-xs-6 col-sm-8 col-md-8 col-lg-8 text-left">
                    <button type="button" class="btn btn-flat btn-send">Добавить</button>
                    <button type="button" class="btn btn-flat btn-cancel">Отменить</button>
                </div>
                <div class="col-xs-6 col-sm-4 col-md-4 col-lg-4 text-right">
                    <button type="button" class="btn btn-flat btn-file">Прикрепить файл</button>
                    <p class="comment-filename"></p>
                    <input type="file" class="comment-file" accept="image/jpeg,image/png,image/gif" />
                </div>
            </div>
        </form>
    </div>
</div>
