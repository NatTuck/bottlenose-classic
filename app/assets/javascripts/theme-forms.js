
$(function() {
    $('select').combobox();

    $('input:text, input:password')
    .button()
    .css({
        'font' : 'inherit',
        'color' : 'inherit',
        'text-align' : 'left',
        'outline' : 'none',
        'cursor' : 'text'
    });

    $('input:submit').button();
});

