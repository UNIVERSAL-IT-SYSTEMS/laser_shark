$ ->

  getEvents = (calendar, startDate, endDate, tags) ->

    $('#eventlist').gCalReader

      calendarId: calendar

      startDate: startDate

      endDate: endDate

      tags: tags

  getLocationCalendar = (location) ->
    if location is 'Toronto'
      calendarLocation = 'functionalimperative.com_du453ucqlvlir8rtf1sdjdd1ak@group.calendar.google.com'
    else
      # Need to get Vancouver calendar address
      calendarLocation = 'en.canadian#holiday@group.v.calendar.google.com'
    return calendarLocation

  getUserDetails = ->
       
    list = $('#eventlist')  
    location = list.data 'location'
    tags = list.data 'tags'
    day = list.data 'day'
    cohortStartDate = list.data 'start-date'
    startDate = calculateDateOfCurriculumDay(day, cohortStartDate, 'start')
    endDate = calculateDateOfCurriculumDay(day, cohortStartDate, 'end')
    calendarLocation = getLocationCalendar(location)
    getEvents(calendarLocation, startDate, endDate, tags)

  calculateDateOfCurriculumDay = (day, startDate, type) ->
    # Get which week/day is currently being viewed
    # Subtract one because if they are week 1, should not add an extra week. Similaraly, if day 2 should only add 1 day and not 2.
    weeks = parseInt(day[1]) - 1
    # If day is a weekend the number of days to add is 5
    if day[3] is undefined
      days = 5
    else
      days = parseInt day[3] - 1
    # Get the date that curriculum day translates to, e.g. w2d1 would be 1 week after the start date
    dateYear = startDate.substring(0,4)
    dateMonth = startDate.substring(5,7)
    dateDay = startDate.substring(8,10)
    startDate = dateMonth + '-' + dateDay + '-' + dateYear
    currentDate = new Date startDate
    currentDate.setDate(currentDate.getDate() + (weeks * 7 + days))
    if type is 'start'
      currentDate.setHours(1)
    else
      currentDate.setHours(23)
    return currentDate.toISOString()

  # Only do request if eventlist element exists on page  
  if $('#eventlist').length is 1
    getUserDetails()
