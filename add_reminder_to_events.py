#!/usr/bin/env python2
from icalendar import Calendar, Event, Alarm

input_file = 'Abfuhrtermine.ics'
output_file = 'Abfalltermine_mit_Erinnerung.ics'

ical_file = open(input_file,'r')
calendar = Calendar.from_ical(ical_file.read())
for component in calendar.walk('VEVENT'):
    valarm_found = False
    for k,v in component.property_items():
        if k == 'BEGIN' and v == 'VALARM':
            valarm_found = True

    if valarm_found == False:
        alarm = Alarm()
        alarm.add('ACTION', 'DISPLAY')
        alarm.add('DESCRIPTION', component.get('SUMMARY'))
        alarm.add('TRIGGER;VALUE=DURATION', '-PT12H')
        component.add_component(alarm)

ical_file.close()
ical_file_new = open(output_file,'w+')
ical_file_new.write(calendar.to_ical())
ical_file_new.close()
