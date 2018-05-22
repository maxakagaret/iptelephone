{var LINKS = <link type="text/css" rel="stylesheet" href="{IMG}style.css" />}

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
            register_event('add-custom-field', export_add_custom_field, collector['name']);
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
        }

        function anchor_delete(anchor) {
            anchor.removeClass('attached');
            setTimeout(function() {
                anchor.remove();
            }, 250);
        }

        function on_save_field(data) {
            data.callback({
                'id': data.id,
                'essence': data.essence,
                'target': data.target,
                'fields': data.fields
            });
        }
        
        function anchor_out_click(anchor) {
            $(document).live('mouseup', function (e) {
                if (anchor.has(e.target).length === 0) {
                    anchor_delete(anchor);
                }

                e.stopPropagation();
            });
        }
        
        function field_value_enter(data, anchor){
            let field_value = anchor.find('.field-value');

            $(document).live('keyup', function(e){
                if(anchor.has(e.target).length !== 0 && $(e.target).hasClass('field-value') && e.which==13 && field_value.val() != '') {
                    data['fields'] = {
                        'name': 'field-name',
                        'value': field_value.val()
                    };

                    on_save_field(data);
                    anchor_delete(anchor);
                }
            });
        }

        function save_btn_click(data, anchor) {
            let field_value = anchor.find('.field-value');

            $(document).live('click', function(e) {
                if(anchor.has(e.target).length !== 0 && $(e.target).hasClass('btn-save')) {
                    if(field_value.val()) {
                        data['fields'] = {
                            'name': 'field-name',
                            'value': field_value.val()
                        };
                        
                        on_save_field(data);
                    }
                    
                    anchor_delete(anchor);
                }
            });
        }

        function export_add_custom_field(data) {
            let after_target_anchor=$('<div class="add-field-anchor"></div>'),
                add_field_form = $(
                    "<div class='add-field-container'>"+
                        "<label class='field-label'>Название поля:</label>"+
                        "<input type='text' class='field-value' placeholder='...' />"+
                        "<div class='text-right'>"+
                            "<button type='button' class='btn btn-save'>Сохранить</button>"+
                        "</div>"+
                    "</div>"
                );
            if(data.target.next().hasClass('add-field-anchor')) {
                anchor_delete(after_target_anchor);
            } else {
                add_field_form.css({
                    'top': -data.target.innerHeight()
                });

                data.target.after(after_target_anchor);

                after_target_anchor.append(add_field_form);

                after_target_anchor.find('.field-value').focus();
                
                setTimeout(function() {
                    after_target_anchor.addClass('attached');
                }, 50);

                anchor_out_click(after_target_anchor);
                
                field_value_enter(data, after_target_anchor);

                save_btn_click(data, after_target_anchor);
            }
            
        }

        dbinit();
    });
    -->
</script>
<div class="{PLUGIN-NAME}-{ID}" data-plugin-name="{PLUGIN-NAME}.{ID}">
</div>