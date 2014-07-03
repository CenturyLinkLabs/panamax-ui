describe('$.fn.appServicesStatus', function() {
    var subject,
        $appServicesStatus;

    var appServicesResponse = {
        0:{
            'id': '77',
            'status': 'foo1',
            'sub_state': 'bar1'
        },
        1:{
            'id': '99',
            'status': 'foo2',
            'sub_state': 'bar2'
        }
    };

    beforeEach(function() {
        jasmine.Ajax.useMock();
        spyOn(window, 'setTimeout');

        fixture.load('service-view-toggle.html');
        $appServicesStatus = $('#teaspoon-fixtures').find('.application-services');

        fixture.load('sorting-services.html');
        $serviceStatus = [
            $('#teaspoon-fixtures').find(".category-panel ul.services li[data-id='77'] a.app-service-status"),
            $('#teaspoon-fixtures').find(".category-panel ul.services li[data-id='99'] a.app-service-status")
        ]

        subject = new $.PMX.AppServicesStatus($appServicesStatus);
    });

    describe('init', function() {

        it('queries the app services endpoint', function() {
            subject.init();
            var request = mostRecentAjaxRequest();
            expect(request.url).toBe('/apps/1/services');
        });

        it('adds a CSS class matching each service status', function() {
            subject.init();
            mockAjaxResponse();

            for (i in appServicesResponse) {
                expect($serviceStatus[i].attr('class')).toContain('app-service-status');
                expect($serviceStatus[i].attr('class')).toContain(appServicesResponse[i].status);
            }
        });

        it('calls window.setTimeout', function() {
            subject.init();
            mockAjaxResponse();

            expect(window.setTimeout).toHaveBeenCalledWith(
                subject.fetchServicesStatus, subject.options.refreshInterval);
        });

        describe('when a request is already in-progress', function() {

            var fakeAjax = {
                abort: function() {},
                done: function() { return fakeAjax; }
            };

            beforeEach(function() {
                subject.xhr = fakeAjax;
                spyOn(fakeAjax, 'abort');
            });

            it('aborts previous requests', function() {
                subject.init();
                expect(fakeAjax.abort.calls.length).toEqual(1);
            });
        });
    });

    var mockAjaxResponse = function() {
        mostRecentAjaxRequest().response({
            status: 200,
            responseText: JSON.stringify(appServicesResponse)
        });
    };
});
