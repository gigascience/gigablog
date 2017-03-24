<?php
/**
 * gigasci functions and definitions
 *
 * @package gigasci
 */

/**
 * To add featured image support in posts
 */
add_theme_support( 'post-thumbnails' );

function pagination($pages = '', $range = 4)
{
	$showitems = ($range * 2)+1;

	global $paged;
	if(empty($paged)) $paged = 1;

	if($pages == '')
	{
		global $wp_query;
		$pages = $wp_query->max_num_pages;
		if(!$pages)
		{
			$pages = 1;
		}
	}

	if(1 != $pages)
	{
	echo "<div class=\"pagination\"><span>Page ".$paged." of ".$pages."</span>";
		if($paged > 2 && $paged > $range+1 && $showitems < $pages) echo "<a href='".get_pagenum_link(1)."'>&laquo; First</a>";
		if($paged > 1 && $showitems < $pages) echo "<a href='".get_pagenum_link($paged - 1)."'>&lsaquo; Previous</a>";

		for ($i=1; $i <= $pages; $i++)
		{
			if (1 != $pages &&( !($i >= $paged+$range+1 || $i <= $paged-$range-1) || $pages <= $showitems ))
			{
			echo ($paged == $i)? "<span class=\"current\">".$i."</span>":"<a href='".get_pagenum_link($i)."' class=\"inactive\">".$i."</a>";
			}
		}

		if ($paged < $pages && $showitems < $pages) echo "<a href=\"".get_pagenum_link($paged + 1)."\">Next &rsaquo;</a>";
		if ($paged < $pages-1 &&  $paged+$range-1 < $pages && $showitems < $pages) echo "<a href='".get_pagenum_link($pages)."'>Last &raquo;</a>";
		echo "</div>\n";
	}
}


add_filter( 'comment_form_default_fields', 'comment_placeholders' );

/**
 * Change default fields, add placeholder and change type attributes.
 *
 * @param  array $fields
 * @return array
 */
function comment_placeholders( $fields )
{
	$fields['author'] = str_replace(
		'<input',
		'<input placeholder="'
		/* Replace 'theme_text_domain' with your theme’s text domain.
		 * I use _x() here to make your translators life easier. :)
		 * See http://codex.wordpress.org/Function_Reference/_x
		 */
		. _x(
			'Name*',
			'comment form placeholder',
			'theme_text_domain'
		)
		. '"',
		$fields['author']
	);
	$fields['email'] = str_replace(
		'<input id="email" name="email" type="text"',
		/* We use a proper type attribute to make use of the browser’s
		 * validation, and to get the matching keyboard on smartphones.
		 */
		'<input type="email" placeholder="Email*"  id="email" name="email"',
		$fields['email']
	);
	$fields['url'] = str_replace(
		'<input id="url" name="url" type="text"',
		// Again: a better 'type' attribute value.
		'<input placeholder="http://example.com" id="url" name="url" type="url"',
		$fields['url']
	);

	return $fields;
}

/**
 * Customise display of comments.
 *
 * @param  array $fields
 * @return array
 */
function gigasci_comment($comment, $args, $depth)
{
	$GLOBALS['comment'] = $comment; ?>
	<li class="comment-list" <?php comment_class(); ?> id="li-comment-<?php comment_ID() ?>">
	<div id="comment-<?php comment_ID(); ?>">
		<div class="comment-author vcard">
			<?php printf(__('<cite class="fn">%s</cite>'), get_comment_author_link()) ?>
		</div>
		<?php if ($comment->comment_approved == '0') : ?>
			<em><?php _e('Your comment is awaiting moderation.') ?></em>
			<br/>
		<?php endif; ?>

		<div class="comment-meta commentmetadata comment-metadata"><a
				href="<?php echo htmlspecialchars(get_comment_link($comment->comment_ID)) ?>"><?php printf(__('%1$s'), get_comment_date()) ?></a><?php edit_comment_link(__('(Edit)'), '  ', '') ?>
		</div>

		<?php comment_text() ?>

		<div class="reply">
			<?php comment_reply_link(array_merge($args, array('depth' => $depth, 'max_depth' => $args['max_depth']))) ?>
		</div>
	</div>
	<?php
}
