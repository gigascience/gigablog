<?php if ( post_password_required() ) {
	return;
} ?>
<div id="comments" class="comments-area">
	<?php if ( have_comments() ) : ?>
		<h3 class="comments-title">
			<?php
			printf( _nx( 'One comment on “%2$s”', '%1$s comments on “%2$s”', get_comments_number(), 'comments title'),
				number_format_i18n( get_comments_number() ), get_the_title() );
			?>
		</h3>
		<ul class="comment-list">
			<?php
			wp_list_comments( array(
				'short_ping'  => true,
				'avatar_size' => 50,
			) );
			?>
		</ul>
	<?php endif; ?>
	<?php if ( ! comments_open() && get_comments_number() && post_type_supports( get_post_type(), 'comments' ) ) : ?>
		<p class="no-comments">
			<?php _e( 'Comments are closed.' ); ?>
		</p>
	<?php endif; ?>

	<?php $comment_args = array(

//	        'title_reply'=>'Got Something To Say:',

	    	'fields' => apply_filters( 'comment_form_default_fields', array(

			'author' => '<p class="comment-form-author">' . '<label for="author">' . __( 'NAME*' ) . '</label> ' . ( $req ? '<span></span>' : '' ) .

				'<input id="author" name="author" type="text" value="' . esc_attr( $commenter['comment_author'] ) . '" size="30"' . $aria_req . ' /></p>',

			'email'  => '<p class="comment-form-email">' .

				'<label for="email">' . __( 'EMAIL*' ) . '</label> ' .

				( $req ? '<span></span>' : '' ) .

				'<input id="email" name="email" type="text" value="' . esc_attr(  $commenter['comment_author_email'] ) . '" size="30"' . $aria_req . ' />'.'</p>',

			'url'    => '' ) ),

		'comment_field' => '<p>' .

			'<label for="comment">' . __( 'COMMENT' ) . '</label>' .

			'<textarea id="comment" name="comment" cols="45" rows="8" aria-required="true"></textarea>' .

			'</p>',

		'comment_notes_after' => '',

	);

	comment_form($comment_args); ?>
</div>