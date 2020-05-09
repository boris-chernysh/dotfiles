#!/usr/bin/env python

import getopt, sys, math

FILLED_BAR_CELL='◼'
FILLED_BAR_COLOR='gray'
URGENT_BAR_COLOR='red'
EMPTY_BAR_CELL='◻'
EMPTY_BAR_COLOR='gray'
DEFAULTS=dict([
    ('max_value', 100),
    ('steps_count', 10),
    ('min_treshold', 0),
    ('max_treshold', math.inf),
    ])

def get_pango_bar(
        value,
        max_value = DEFAULTS['max_value'],
        steps_count = DEFAULTS['steps_count'],
        min_treshold = DEFAULTS['min_treshold'],
        max_treshold = DEFAULTS['max_treshold'],
        ):
    division_cost = max_value / steps_count

    filled_cells_count = math.ceil(value / division_cost)
    empty_cells_count = math.floor((max_value - value) / division_cost)

    filled_color = FILLED_BAR_COLOR if value > min_treshold and value < max_treshold else URGENT_BAR_COLOR

    return (
            f'<span color=\'{filled_color}\'>{FILLED_BAR_CELL * filled_cells_count}</span>'
            f'<span color=\'{EMPTY_BAR_COLOR}\'>{EMPTY_BAR_CELL * empty_cells_count}</span>'
            )

if __name__ == '__main__':
    try:
        opts, args = getopt.getopt(sys.argv[1:], '', [
            'max-value=',
            'steps-count=',
            'min-treshold=',
            'max-treshold='
            ])
    except getopt.GetoptError as err:
        print(err)
        sys.exit(2)

    value = round(float(args[0]))
    max_value = DEFAULTS['max_value']
    steps_count = DEFAULTS['steps_count']
    min_treshold = DEFAULTS['min_treshold']
    max_treshold = DEFAULTS['max_treshold']

    for opt, arg in opts:
        if opt == '--max-value':
            max_value = float(arg)
        if opt == '--steps-count':
            steps_count = int(arg)
        if opt == '--min-treshold':
            min_treshold = float(arg)
        if opt == '--max-treshold':
            max_treshold = float(arg)

    print(get_pango_bar(value, max_value, steps_count, min_treshold, max_treshold))
