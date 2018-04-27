var caption_label = 'a';

function increment_caption_counter() { caption_label = String.fromCharCode(caption_label.charCodeAt(0) + 1); }
function reset_caption_counter() { caption_label = 'a'; }

function add_image(uri, caption)
{
	document.write('<td><a href="' + uri + '"><img width="100%"\
	src="' + uri + '" /></a><br />(' + caption_label + ') ' + caption + '</td>');
	increment_caption_counter();
}

function add_image_with_width(uri, caption, width)
{
	document.write('<td><a href="' + uri + '"><img width="' + width + '"\
	src="' + uri + '" /></a><br />(' + caption_label + ') ' + caption + '</td>');
	increment_caption_counter();
}

function add_image_with_height(uri, caption, height)
{
	document.write('<td><a href="' + uri + '"><img height="' + height + '"\
	src="' + uri + '" /></a><br />(' + caption_label + ') ' + caption + '</td>');
	increment_caption_counter();
}
