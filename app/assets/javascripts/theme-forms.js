
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

    $('.rich-text').each(function (ii) {
	new nicEditor({iconsPath: '/assets/nicEditorIcons.gif'}).panelInstance(this.id);
    });
});

