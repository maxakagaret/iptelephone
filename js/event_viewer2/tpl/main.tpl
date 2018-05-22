{var LINKS = <link type="text/css" rel="stylesheet" href="{IMG}event_viewer.css" />}

<script type="text/javascript" src="{JS}autogrow.jquery.js"></script>
<script type="text/javascript">
    <!--
    $(document).ready(function() {
        var settings = JSON.parse('{PLUGIN-SETTINGS}' || null);

        var events = [];

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
            register_event('update-events', export_update_events, collector['name']);
            register_event('add-event', export_add_event, collector['name']);
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
            
            ssb_fire('update-events', get_test_data());
        }

        function get_test_data() {
            return [
            {
                'id': 1,
                'type': 'call',
                'date': 'Апрель',
                'payload': {
                    'calldate': '2018-04-11 20:23:12',
                    'src': 'Чижиков Андрей (79641234567)',
                    'dst': '74957852929 (Офис)',
                    'disposition': 'ANSWERED',
                    'calltype': 'IN',
                    'duration': '32'
                }
            },
            {
                'id': 2,
                'type': 'comment',
                'date': 'Апрель',
                'payload': {
                    'date': '2018-04-12 13:27',
                    'user': 'Иванов Иван',
                    'comment': 'retailCRM изначально позиционировалась как CRM-система для интернет-торговли, одним из ее ключевых преимуществ заявляется возможность обработки заказов в режиме «одного окна» с момента получения заявки до доставки. Имеет открытый API, способный удовлетворить самые разные запросы по интеграции с сайтами, лэндингами, другими системами.'
                }
            },
            {
                'id': 3,
                'type': 'comment',
                'date': 'Апрель',
                'payload': {
                    'date': '2018-04-12 16:27',
                    'user': 'Чижиков Андрей',
                    'comment': 'Спасибо Вам за предоставленную информацию по запросу на поиск специалистов телемаркетинга'
                }
            },
            {
                'id': 4,
                'type': 'call',
                'date': 'Май',
                'payload': {
                    'calldate': '2018-05-18 20:23:12',
                    'src': '203',
                    'dst': '74957852929',
                    'disposition': 'ANSWERED',
                    'calltype': 'OUT',
                    'duration': '32'
                }
            },
            {
                'id': 5,
                'type': 'comment',
                'date': 'Май',
                'payload': {
                    'date': '2018-05-12 16:27',
                    'user': 'Иванов Иван',
                    'comment': 'Спасибо Вам за предоставленную информацию по запросу на поиск специалистов телемаркетинга'
                }
            },
            {
                'id': 6,
                'type': 'call',
                'date': 'Июнь',
                'payload': {
                    'calldate': '2018-05-18 20:23:12',
                    'src': '203',
                    'dst': '74957852929',
                    'disposition': 'ANSWERED',
                    'calltype': 'OUT',
                    'duration': '32'
                }
            },
            {
                'id': 7,
                'type': 'comment',
                'date': 'Июнь',
                'payload': {
                    'date': '2018-05-12 16:27',
                    'user': 'Иванов Иван',
                    'comment': 'Спасибо Вам за предоставленную информацию по запросу на поиск специалистов телемаркетинга'
                }
            }
            ];
        }

        function get_expanded_height(block){
            let height = 0;

            block.find('.event-item').each(function() {
                height += $(this).outerHeight(true);
            });

            return height;
        }

        function toggle_collapse_block(block, button=false) {
            let height = 0;
            
            if(!button){
                button = block.closest('.events-group').find('.btn-collapse');
            }

            if (!block.hasClass('expand')) {

                height = get_expanded_height(block);

                block.addClass('expand');
                button.addClass('opened');

            } else {
                
                block.removeClass('expand');
                button.removeClass('opened');

            }
            
            block.animate({height: height}, 150, 'swing', function() {
                if(height!=0) {
                    setTimeout(function() {
                        block.height('auto');
                    }, 150);
                }
            });
        }

        function build_event_block(id, type, icon, header_line, body_data) {
            return (
                '<div class="event-item ' + type + '" data-event-id="' + id + '">' +
                    '<input type="hidden" name="event-id" value="' + id + '" />' +
                    icon +
                    '<div class="content">' +
                        header_line +
                        body_data + 
                    '</div>' +
                '</div>'
            );
        }

        function build_call(event) {
            let header_line = '',
                body_data = '',
                call_date = new Date(event['payload']['calldate']),
                months = ['Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'],
                icon = (
                    event['payload']['calltype'] == 'IN' ? 
                    '<i class="icon fa fa-arrow-right fa-2x pull-left in"></i>' :
                    '<i class="icon fa fa-arrow-left fa-2x pull-left out"></i>'
                );
            
            call_date = call_date.getDate() + ' ' + months[call_date.getMonth()] + ', ' + call_date.getHours() + ':' + call_date.getMinutes();
            
            header_line = (
                '<h4 class="header">' + call_date + (event['payload']['calltype'] == 'IN' ? ' Входящий': ' Исходящий') +
                    ' звонок <a href="#" class="call-icon"></a>' + 
                '</h4>'
            );

            body_data = (
                '<div>' +
                    'Клиент: ' + event['payload']['src'] + '<br/>' +
                    'Звонок поступил на номер: ' + event['payload']['dst'] + '<br/>' +
                    'Длительность: ' + Math.floor(event['payload']['duration']/60) + ':' + (event['payload']['duration']%60) +
                '</div>'
            );

            return build_event_block(event['id'], event['type'], icon, header_line, body_data);
        }

        function build_comment(event) {
            let header_line = '',
                body_data = '',
                icon = '',
                months = ['Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'],
                call_date = new Date(event['payload']['date']);
                        
            call_date = call_date.getDate() + ' ' + months[call_date.getMonth()] + ', ' + call_date.getHours() + ':' + call_date.getMinutes();
            
            header_line = '<h4 class="header">' + call_date + ' ' + event['payload']['user'] + '</h4>';
            
            body_data = 
                '<textarea autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false">' + event['payload']['comment'] + '</textarea>'+
                '<div class="after-text-stripe"></div>';

            return build_event_block(event['id'], event['type'], icon, header_line, body_data);
        }

        function build_comment_content(event) {
            let header_line = '',
                body_data = '',
                months = ['Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'],
                call_date = new Date(event['payload']['date']);
                        
            call_date = call_date.getDate() + ' ' + months[call_date.getMonth()] + ', ' + call_date.getHours() + ':' + call_date.getMinutes();
            
            header_line = call_date + ' ' + event['payload']['user'];
            
            body_data = event['payload']['comment'];
            
            return {'header': header_line, 'body': body_data};
        }

        function build(data) {
            let сontainer = $('.{PLUGIN-NAME}-{ID} .events-container'),
                expanded_blocks = 0;
            
            if (settings['opened-count'] > 0) {
                expanded_blocks = parseInt(settings['opened-count'], 10);
            }
            
            сontainer.empty();

            for (let group in data) {
                
                let group_data = data[group],
                    items = '';
                
                $.each(group_data, function(index, event) {
                    
                    let event_block = '';

                    switch (event['type']) {
                        case 'call': event_block = build_call(event); break;
                        case 'comment': event_block = build_comment(event); break;
                        default: event_block = build_comment(event); break;
                    }
                    
                    items += event_block;

                });

                сontainer.append(
                    '<div data-event-group = "' + group + '" class="events-group">' +
                        '<h3><span>' + group + '</span></h3>' +
                        '<div class = "collapse-box">' + items + '</div>' +
                        '<div class="btn btn-flat btn-collapse"><i class="fa fa-chevron-circle-down"></i></div>' +
                    '</div>'
                );

                $('.{PLUGIN-NAME}-{ID} .events-container .event-item.comment .content textarea').autogrow(); 

                if(expanded_blocks>0){
                    
                    let block = сontainer.find('[data-event-group = "' + group + '"] .collapse-box');

                    toggle_collapse_block(block);
                    
                    expanded_blocks--;
                }
            }
        }

        function rebuild(is_new, event, events_group=''){
            let container = $('.{PLUGIN-NAME}-{ID} .events-container');

            if(is_new) {

                let event_block = '',
                    collapse_box = container.find('[data-event-group="' + events_group + '"] .collapse-box');
                
                switch (event['type']) {
                    case 'call': event_block = build_call(event); break;
                    case 'comment': event_block = build_comment(event); break;
                    default: event_block = build_comment(event); break;
                }

                collapse_box.append(event_block);
                collapse_box.find('textarea').autogrow();
                
                if (collapse_box.hasClass('expand')) {
                    collapse_box.innerHeight(get_expanded_height(collapse_box));    
                } else{
                    toggle_collapse_block(collapse_box);
                }

            } else {

                let event_block = container.find('.event-item[data-event-id="' + event['id'] + '"]'),
                    event_content_header = event_block.find('.header'),
                    event_content_text = event_block.find('textarea'),
                    content = build_comment_content(event),
                    collapse_box = event_block.closest('.collapse-box');
                
                event_content_header.text(content['header']);
                event_content_text.val(content['body']);

                if (collapse_box.hasClass('expand')) {
                    collapse_box.innerHeight(get_expanded_height(collapse_box));
                } else{
                    toggle_collapse_block(collapse_box);
                }
            }
        }

        $('.{PLUGIN-NAME}-{ID} .events-container .event-item.call .call-icon').live('click', function() {
            alert('call the player');
        });

        $('.{PLUGIN-NAME}-{ID} .events-container .btn-collapse').live('click', function() {
            let box = $(this).closest('.events-group').find('.collapse-box');

            toggle_collapse_block(box, $(this));
        });

        $('.{PLUGIN-NAME}-{ID} .events-container .events-group h3').live('click', function() {    
            let box = $(this).closest('.events-group').find('.collapse-box'),
                collapse_button=$(this).closest('.events-group').find('.btn-collapse');
            
            toggle_collapse_block(box, collapse_button);
        });

        $('.{PLUGIN-NAME}-{ID} .events-container .event-item.comment .content textarea').live('change', function(e) {
            let textarea = $(this),
                event_id=textarea.closest('.event-item.comment').find('[name="event-id"]').val();
            
            ssb_fire('save-field', {
                'custom': 0,
                'essence': 'event',
                'id': event_id,
                'field': '',
                'value': textarea.val()
            });
        });

        function export_update_events(data) {
            events = [];
            
            $.each(data, function(index, value) {
                let date = value.date;
                
                if (!events[date]) {
                    events[date] = [];
                }
                
                events[date].push({
                    'id': value['id'],
                    'type': value['type'],
                    'payload': value['payload']
                });
            });

            build(events);
        }

        function check_comment_events(data){
            let date_group = data['date'],
                new_event_date = new Date(data['payload']['date']).getTime(),
                events_group_to_add = events[date_group],
                error = '',
                flag = -1;

            if(events_group_to_add.length>0) {
                let last_event = events_group_to_add[events_group_to_add.length - 1];
                
                if(last_event['type'] = ='comment') {

                    if(data['id'] == last_event['id']) {
                    
                        error += 'event already added; ';
                        return false;

                    } else {

                        let current_event_date = new Date(last_event['payload']['date']).getTime();

                        if(
                            (new_event_date - current_event_date) <= 300000 && 
                            data['payload']['user'] == last_event['payload']['user']) {
                           
                            flag = index;
                            return false;

                        }
                    }
                }
            }

            return {'error':error,'flag':flag};
        }

        function export_add_event(data){
            let date_group = data['date'];
            
            if(data['type'] == 'comment') {

                let check_results = check_comment_events(data);

                if(check_results['error'] == '') {

                    if(check_results['flag'] < 0) {
                        
                        let new_event = {
                            'id': data['id'],
                            'type': data['type'],
                            'payload': data['payload']
                        };
                        
                        rebuild(true, new_event, data['date']);

                    } else {

                        let payload = events[date_group][check_results['flag']]['payload'];

                        payload['comment'] = payload['comment'] + ' ' + data['payload']['comment'];
                        payload['date'] = data['payload']['date'];

                        let new_event = {
                            'id': events[date_group][check_results['flag']]['id'],
                            'type': data['type'],
                            'payload': payload
                        };

                        rebuild(false, new_event);

                    }
                }
            } else {

                let new_event = {
                    'id': data['id'],
                    'type': data['type'],
                    'payload': data['payload']
                };

                rebuild(true, new_event, data['date']);

            }
        }

        dbinit();
    });
-->
</script>

<div class="{PLUGIN-NAME}-{ID}" data-plugin-name="{PLUGIN-NAME}.{ID}">
    <div class="events-container">
    </div>
</div>