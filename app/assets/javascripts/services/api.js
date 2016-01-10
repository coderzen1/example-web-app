modulejs.define('services/api', ['config'], function(config) {

  function getScemids() {
    return $.ajax({
      url: config.API_URL + '/token/tour/scemids',
      data: {
        token: config.API_TOKEN,
        Descending: true,
        source: 'ArrivalBoard'
      },
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }

  function getTours(data) {
    var dfd = new $.Deferred();
    var idPages = [];
    var batchData = [];

    while (data.scemids.length) {
      idPages.push(data.scemids.splice(0, 10));
    }

    function _getTours() {
      if (idPages.length) {
        var ids = idPages.shift();
        $.ajax({
          url: config.API_URL + '/tour/batch',
          data: {
            token: config.API_TOKEN,
            scemids: ids.join(',')
          },
          headers: {
            'Content-Type': 'application/json'
          }
        }).then(function(data) {
          _.each(data.tours, function(tour) {
            batchData = batchData.concat(tour.stops);
          });
          _getTours();
        }, dfd.reject);
      } else {
        dfd.resolve(batchData);
      }
    }
    _getTours();
    return dfd.promise();
  }

  function getEtas(batchData) {
    return $.ajax({
      url: config.API_URL + '/stop/batch/eta/',
      data: {
        token: config.API_TOKEN,
        scemids: _.pluck(batchData, 'scemid').join(',')
      },
      headers: {
        'Content-Type': 'application/json'
      }
    }).then(function(data) {
      _.each(data.stopTimeInfos, function(info) {
        var stopInfo = _.findWhere(batchData, {scemid: info.stopSCEMID});
        stopInfo.etas = info;
      });
      return batchData;
    });
  }

  return {
    getETAs: function() {
      return getScemids()
        .then(getTours)
        .then(getEtas);
    }
  };
});
