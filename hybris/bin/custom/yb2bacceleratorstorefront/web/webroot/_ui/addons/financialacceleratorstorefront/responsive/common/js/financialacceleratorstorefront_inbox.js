ACC.inbox = {
    inboxContainer: $('#inbox'),
    getInboxTabContentUrl: 'inbox/tab',
    selectedMessages: [],
    group: '',
    sort: $('#inbox').find('.js-sort'),
    thCheckBox: $('#inbox').find('.js-check-main input'),

    _autoload: [
        ['inbox', $('#inbox').length > 0],
        ['bindInboxPagination', $('#inbox').length > 0]
    ],

    inbox: function() {
        //first enable click events, disabled by css needed to prevent fast clicking before content loads
        ACC.inbox.inboxContainer.css('pointer-events', 'auto');
        //load messages
        ACC.inbox.group = $('.tabs-list .active').attr('group');// set initial active tab group
        var mutationObserver = new MutationObserver(function(mutations) {
            mutations.forEach(function() {
                ACC.inbox.group = $('.tabs-list .active').attr('group');// set active tab group after tab change (after each AJAX call)
            });
        });
        mutationObserver.observe(document.getElementsByClassName('tabs-list')[0], {
            attributes: true,
            attributeFilter: ['class'],
            subtree: true
        });
        if (ACC.inbox.group !== undefined) {
            this.getMessageListContent(ACC.inbox.group, 1, '', '');
            ACC.inbox.inboxContainer.on('change', ACC.inbox.thCheckBox, function(){
                ACC.inbox.selectedMessages = $('.msg-selected input');
                ACC.inbox.changeIcon();
            });
        } else {
            $('.no-messages-info').removeClass('no-show');
            ACC.inbox.inboxContainer.find('.tabs-responsive').addClass('no-show');
        }
        //Setting the right label on dropdown button
        var tabsList = ACC.inbox.inboxContainer.find('.tabs-list');
        //Needed as an IIFE so it will fire on load but can be used in some other event
        var textChange = (function changeText () {
            tabsList.find('.current-info').remove();
            var activeText = tabsList.find('.active a').text();
            ACC.inbox.inboxContainer.find('.dropdown-category').text(activeText);
            return changeText;
        })();

        tabsList.find('a').on('click', function() {
            textChange();
            ACC.inbox.thCheckBox.prop('checked', false);//reseting checkbox in TH
            var groupActive = $(this).parent().attr('group');
            ACC.inbox.sort.attr('sort-order', 'desc').removeClass('top');//reset sorting on tab change
            ACC.inbox.getMessageListContent(groupActive, 1, '', '');//get messages for the current tab
        });
        //triggering tab change in mobile view
        var mobileDropdown = $('#mobile-dropdown');
        var dropdownMenu = mobileDropdown.find('.dropdown-menu > li');
        dropdownMenu.each(function() {
            $(this).on('click', function(e) {
                e.preventDefault();
                var mobileGroup = $(this).attr('group');
                tabsList.find('li[group="' + mobileGroup + '"] > a').click();
                mobileDropdown.removeClass('open');
            });
        });
        //toggling all checkboxes based on the one in TH
        ACC.inbox.inboxContainer.on('click', '.js-check-main input', function() {
            var allRows = ACC.inbox.inboxContainer.find('.tr');
            var allChecks = ACC.inbox.inboxContainer.find('.js-check-toggle input');
            if ( $(this).prop('checked') === true) {
                ACC.inbox.thCheckBox.not($(this)).prop('checked', true);
                allChecks.prop('checked', true);
                allRows.addClass('msg-selected');
            } else {
                ACC.inbox.thCheckBox.not($(this)).prop('checked', false);
                allChecks.prop('checked', false);
                allRows.removeClass('msg-selected');
            }
        });

        //toggling TH checkbox based on the states of other checkboxes
        ACC.inbox.inboxContainer.on('click', '.js-check-toggle input', function() {
            var row = $(this).parents('.tr');
            ACC.inbox.thCheckBox.each(function() {
                return $(this).prop('checked') === true ? $(this).prop('checked', false) : null;
            });
            return $(this).prop('checked') === true ? row.addClass('msg-selected') : row.removeClass('msg-selected');
        });
        //Get all selected messages UID attribute and on envelope icon click, trigger the sync
        ACC.inbox.inboxContainer.on('click', '.js-update-messages-state', function() {
            var getSelectedmessagesUIDs = ACC.inbox.inboxContainer.find('.msg-selected .js-check-toggle');
            var UIDArray = [];
            $.each(getSelectedmessagesUIDs, function() {
                UIDArray.push($(this).attr('data-uid'));
            });
            ACC.inbox.sendData(UIDArray, ACC.inbox.setMessagesAction(ACC.inbox.selectedMessages));
        });
        //Trigger sorting
        ACC.inbox.inboxContainer.on('click', '.js-sort', function () {
            var pagination = $('.pagination').find('.active > span');
            pagination.children().remove();
            ACC.inbox.sort.not($(this)).removeClass('active');
            $(this).addClass('active').toggleClass('top');
            $(this).attr('sort-order', function (index, attribute) {
                return attribute === 'desc' ? 'asc' : 'desc';
            });
            ACC.inbox.getMessageListContent(ACC.inbox.group, pagination.text(), $(this).attr('sort-code'), $(this).attr('sort-order'));
        });
    },
    //Send ajax, to sync the FE with BE state
    sendData: function(UIDArray, messageAction) {
        if (UIDArray.length === 0) { return; }
        var url = 'inbox/messages/read-unread';
        var action = messageAction === 'read';
        var data = {messages: UIDArray, read: action};
        $.ajax({
            url: url,
            type: 'POST',
            traditional: 'true',
            data: data,
            success: function() {
                //Set the new state by setting right message class
                ACC.inbox.inboxContainer.find('.msg-selected').removeClass('read unread').addClass(messageAction);
                ACC.inbox.changeIcon();
            }
        });
    },
    // Function for getting message list
    getMessageListContent: function (group, page, sortCode, sortOrder) {
        $.ajax({
            url: ACC.inbox.getInboxTabContentUrl,
            type: 'GET',
            data: {messageGroup: group, page: page === '' ? 0 : page - 1, sortCode: sortCode, sortOrder: sortOrder},
            dataType: 'html',
            success: function (data) {
                if (data !== undefined && data !== '') {
                    $('.message-content').html($(data).find('.messages'));
                    $('.pagination-content').html($(data).find('#paginationFragment'));
                }
            }
        }).done(function() {
            //Accordions for viewing messages
            $('.js-msg-trigger').on('click', function() {
                var $thatParent = $(this).parent();
                var messageUid = $(this).siblings('.td1').children('.js-check-toggle').attr('data-uid');
                if ($thatParent.hasClass('active')) {
                    $thatParent.removeClass('active').next().addClass('read').removeClass('opened').slideUp();
                } else {
                    $thatParent.addClass('active').next().slideDown().addClass('opened');
                    if ($thatParent.hasClass('unread')) { //sync the message only if it's unread
                        ACC.inbox.sendData(messageUid, 'read');
                    }
                    $thatParent.removeClass('unread').addClass('read');
                }
            });
        });
    },
    //Set the action according to the previous messages states, if mixed states, unread all messages
    setMessagesAction: function (selectedMessages) {
        var messagesAction = 'read';
        $.each(selectedMessages, function() {
            if($(this).parents('.tr').hasClass('read')) {
                messagesAction = 'unread';
            }
        });
        return messagesAction;
    },
    //Set action icon, accoriding to the messageAction return value
    changeIcon: function () {
        var messageAction = ACC.inbox.setMessagesAction(ACC.inbox.selectedMessages);
        var $messageIcon = $('.js-update-messages-state');
        if (ACC.inbox.selectedMessages.length !== 0) {
            return messageAction !== 'read' ? $messageIcon.addClass('opened') : $messageIcon.removeClass('opened');
        }
        return true;
    },

    // Make ajax pagination, prevent default behavior
    bindInboxPagination: function () {
        ACC.inbox.inboxContainer.on('click', '.pagination a', function (e) {
            e.preventDefault();
            var element = $(this);
            ACC.inbox.thCheckBox.prop('checked', false);//reseting checkbox in TH
            var activeSortGroup = $('.js-sort.active');
            var page = element.text();
            //handle click on arrows
            if (element.attr('rel') !== '') {
                var elementHref = element.attr('href');
                page = parseInt(elementHref.substring(elementHref.indexOf('=') + 1, 10)) + 1;
            }
            ACC.inbox.getMessageListContent(ACC.inbox.group, page, activeSortGroup.attr('sort-code'), activeSortGroup.attr('sort-order'));
        });
    }
};
