describe('SoundcloudDownloadController', function() {
	beforeEach(module('SoundcloudDownload'));

	var scope, ctrl;

	beforeEach(inject(function($rootScope, $controller) {
		scope = $rootScope.$new();
		ctrl = $controller('SoundcloudDownloadController', {
			$scope: scope
		})
	}))

	it ('initialises with an empty list', function() {
		expect(scope.downloadableStream).toBeUndefined();
	});
});