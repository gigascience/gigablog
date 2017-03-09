<?php get_header(); ?>

    <div class="row">

        <div class="col-sm-9 blog-main">

            <h1 class="latest-posts-styling">Latest posts</h1>

			<?php
			if ( have_posts() ) : while ( have_posts() ) : the_post();

				get_template_part( 'content', get_post_format() );

			endwhile; ?>

            <?php if (function_exists("pagination")) {
                pagination($additional_loop->max_num_pages);
            } ?>

            <?php endif;
			?>

        </div> <!-- /.blog-main -->

		<?php get_sidebar(); ?>

    </div> <!-- /.row -->

<?php get_footer(); ?>