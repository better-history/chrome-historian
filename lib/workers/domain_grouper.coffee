@BH = BH ? {}
BH.Workers = BH.Workers ? {}

class BH.Workers.DomainGrouper
  run: (@intervals) ->
    for interval in @intervals
      interval.visits = @groupByDomain(interval.visits)
    @intervals

  groupByDomain: (visits) ->
    groupedVisits = []
    previous = null
    for visit in visits
      if groupedVisits.length == 0
        groupedVisits.push(visit)
        previous = visit
      else
        if @hasSameDomain(visit, previous)
          if !groupedVisits[groupedVisits.length - 1].length?
            groupedVisits.pop()
            groupedVisits.push([previous, visit])
          else
            groupedVisits[groupedVisits.length - 1].push(visit)
        else
          groupedVisits.push(visit)
      previous = visit
    groupedVisits

  hasSameDomain: (visit1, visit2) ->
    if (visit1? && visit2?)
      if @extractDomain(visit1) == @extractDomain(visit2)
        return true
    false

  extractDomain: (visit) ->
    match = visit.url.match(/\/\/(.*?)\//)
    if match == null then null else match[0]

unless onServer?
  self.addEventListener 'message', (e) ->
    grouper = new BH.Workers.DomainGrouper()
    postMessage grouper.run(e.data.intervals)
