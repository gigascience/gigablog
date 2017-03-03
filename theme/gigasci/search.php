<?php
/**
 * The template for displaying Search Results pages.
 *
 * @package dazzling
 */

get_header(); ?>
<div class="row">
    <div class="col-sm-9 blog-main">

			<?php if ( have_posts() ) : ?>

                <h4 class="latest-posts-styling"><?php printf( __( 'Search Results for: %s', 'gigasci' ), '<span>' . get_search_query() . '</span>' ); ?></h4>

				<?php /* Start the Loop */ ?>
				<?php while ( have_posts() ) : the_post(); ?>

					<?php get_template_part( 'content', 'search' ); ?>

				<?php endwhile; ?>

			<?php else : ?>

				<?php get_template_part( 'content', 'none' ); ?>

			<?php endif; ?>

    </div>
	<?php get_sidebar(); ?>
</div> <!-- /.row -->

<?php get_footer(); ?>
