<?php
/**
 * The template for displaying Archive pages
 *
 * Used to display archive-type pages if nothing more specific matches a query.
 * For example, puts together date-based pages if no date.php file exists.
 *
 * If you'd like to further customize these archive views, you may create a
 * new template file for each specific one. For example, Twenty Fourteen
 * already has tag.php for Tag archives, category.php for Category archives,
 * and author.php for Author archives.
 *
 * @link https://codex.wordpress.org/Template_Hierarchy
 *
 * @package WordPress
 * @subpackage gigasci
 * @since
 */

get_header(); ?>

    <div class="row">

        <div class="col-sm-9 blog-main">

			<?php if ( have_posts() ) : ?>

                    <h1 class="latest-posts-styling">
						<?php
						if ( is_day() ) :
							printf( __( 'Daily Archives: %s', 'gigasci' ), get_the_date() );

						elseif ( is_month() ) :
							printf( __( 'Monthly Archives: %s', 'gigasci' ), get_the_date( _x( 'F Y', 'monthly archives date format', 'gigasci' ) ) );

						elseif ( is_year() ) :
							printf( __( 'Yearly Archives: %s', 'gigasci' ), get_the_date( _x( 'Y', 'yearly archives date format', 'gigasci' ) ) );

						else :
							_e( 'Archives', 'gigasci' );

						endif;
						?>
                    </h1>

				<?php
				// Start the Loop.
				while ( have_posts() ) : the_post();

					/*
					 * Include the post format-specific template for the content. If you want to
					 * use this in a child theme, then include a file called called content-___.php
					 * (where ___ is the post format) and that will be used instead.
					 */
					get_template_part( 'content', get_post_format() );

				endwhile;
				// Previous/next page navigation.
//				twentyfourteen_paging_nav();

			else :
				// If no content, include the "No posts found" template.
				get_template_part( 'content', 'none' );

			endif;
			?>

        </div><!-- #content -->

        <?php get_sidebar(); ?>
    </div><!-- #primary -->

<?php
get_footer();