<?php get_header(); ?>

    <div class="row">

        <div class="col-sm-9 blog-main">

            <h4 class="latest-posts-styling">Latest posts</h4>

			<?php query_posts('posts_per_page=4'); ?>

			<?php
			if ( have_posts() ) : while ( have_posts() ) : the_post();

				get_template_part( 'content', get_post_format() );

			endwhile; ?>

                <nav>
                    <ul class="pager">
                        <li><?php next_posts_link( 'Previous' ); ?></li>
                        <li><?php previous_posts_link( 'Next' ); ?></li>
                    </ul>
                </nav>

            <?php endif;
			?>

        </div> <!-- /.blog-main -->

		<?php get_sidebar(); ?>

    </div> <!-- /.row -->

<?php get_footer(); ?>