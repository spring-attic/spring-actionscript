$(init);

function init()
{
	$("a.asclass").each(createTooltip);
	$("a.asclassdetail").each(createTooltip);
}

function createTooltip()
{
	if ($(this).children().length > 0)
	{
		var sibl = $(this).children()[0];
		if (sibl.className == "toolTipContent")
		{
			$(this).wTooltip({
			    delay: 500,
			    content: true,
			    fadeIn: 600,
			    fadeOut: "slow",
			    callBefore: function(tooltip) {
			    	$(tooltip).html($(sibl).text());
			    }
			});
		}
	}
}