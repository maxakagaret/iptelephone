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

        function build_event_bloc(id, type, icon, header_line, body_data) {
            return (
                '<div class="event-item ' + type + '">' +
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
            return build_event_bloc(event['id'], event['type'], icon, header_line, body_data);
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
                '<textarea>' + event['payload']['comment'] + '</textarea>'+
                '<div class="after-text-stripe"></div>';

            return build_event_bloc(event['id'], event['type'], icon, header_line, body_data);
        }

        function build(data) {
            let сontainer = $('.{PLUGIN-NAME}-{ID} .events-container');                
            
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
            }
        }

        $('.{PLUGIN-NAME}-{ID} .events-container .event-item.call .call-icon').live('click', function() {
            alert('call the player');
        });

        $('.{PLUGIN-NAME}-{ID} .events-container .btn-collapse').live('click', function() {
            let box = $(this).closest('.events-group').find('.collapse-box');
            let height = 0;
            
            if (!$(this).hasClass('opened')) {
                box.find('.event-item').each(function() {
                    height += $(this).outerHeight(true);
                });

                $(this).addClass('opened');
            } else {
                $(this).removeClass('opened');
            }
            
            box.animate({height: height}, 150, 'swing');
        });

        $('.{PLUGIN-NAME}-{ID} .events-container .events-group h3').live('click', function() {
            let box = $(this).closest('.events-group').find('.collapse-box'),
                collapse_button=$(this).closest('.events-group').find('.btn-collapse'),
                height = 0;
            
            if (!collapse_button.hasClass('opened')) {
                box.find('.event-item').each(function() {
                    height += $(this).outerHeight(true);
                });

                collapse_button.addClass('opened');
            } else {
                collapse_button.removeClass('opened');
            }
            
            box.animate({height: height}, 150, 'swing');
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
                    'id': value.id,
                    'type': value.type,
                    'payload': value.payload
                });
            });

            build(events);
        }

        function export_add_event(data){
            /*
            'id': '123',
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
            */
            let date_group = data['date'],
                events_group_to_add = events[date_group],
                new_event_date = data['type']=='call' ? new Date(data['payload']['calldate']).getTime() : new Date(data['payload']['date']).getTime(),
                error = '',
                flag = -1;
            
            if(events_group_to_add.length > 0) {
                
                $.each(events_group_to_add, function(index, value) {
                    if(data['id']==value['id']) {

                        error += 'event already added; ';
                        return false;

                    } else {

                        let current_event_date = value['type']=='call' ? new Date(value['payload']['calldate']).getTime() : new Date(value['payload']['date']).getTime();

                        if(
                            (new_event_date - current_event_date) <= 300000 && 
                            data['type'] == 'comment' && 
                            data['payload']['user'] == value['payload']['user']){
                           
                            flag = index;
                            return false;

                        }
                    }
                });

                if(error == '') {

                    if(flag < 0) {

                        events[date_group].push({
                            'id': data['id'],
                            'type': data['type'],
                            'payload': data['payload']
                        });

                    } else {

                        if(events[date_group][flag]['type'] == 'comment') {

                            events[date_group][flag]['payload']['date'] = data['payload']['date'];
                            events[date_group][flag]['payload']['comment'] = events[date_group][flag]['payload']['comment'] + ' ' + data['payload']['comment'];

                        }

                        console.log(events[date_group][flag]);

                    }

                    build(events);

                } else {

                    console.log(error);

                }
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