class Dashing.LanternDataIngest extends Dashing.Widget
  @accessor 'current', Dashing.AnimatedValue

  onData: (data) ->
    metric = data.metric.split("-")
    inputDate = new Date(metric[2], metric[1] - 1, metric[0]);
    todaysDate = new Date();

    if inputDate.setHours(0,0,0,0) == todaysDate.setHours(0,0,0,0)
      $(@get('node')).removeClass 'ingest-error'
    else
      $(@get('node')).addClass 'ingest-error'

    if data.type == 'realtime'
      if data.status == 'ok'
        $(@get('node')).removeClass 'ingest-error'
      else
        $(@get('node')).addClass 'ingest-error'

