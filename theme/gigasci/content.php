<div class="blog-post">
	<h3 class="blog-post-title"><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h3>
    <p><?php the_author_posts_link(); ?> - <?php the_date(); ?></p>

    <div class="row top-buffer">
        <div class="col-md-2">
            <?php if ( has_post_thumbnail() ) {
                the_post_thumbnail('thumbnail');
            }
            ?>
        </div>
        <div class="col-md-7 col-md-offset-1">
	        <?php the_excerpt(); ?>
            <p><a class="btn btn-default read-more" href="<?php the_permalink(); ?>"><?php _e( 'Continue reading', 'gigasci' ); ?> <i class="fa fa-chevron-right"></i></a></p>
        </div>
    </div>

    <a href="<?php comments_link(); ?>">
		<?php
		printf( _nx( '1 comment', '%1$s comments', get_comments_number(), 'comments title', 'textdomain' ), number_format_i18n( get_comments_number() ) ); ?>
    </a>
</div><!-- /.blog-post -->