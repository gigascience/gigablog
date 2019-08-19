<?php
/**
 * The template for displaying Author archive pages
 *
 * @link https://codex.wordpress.org/Template_Hierarchy
 *
 * @package gigablog.com
 * @subpackage gigasci
 * @since
 */

get_header(); ?>

	<div class="row">

		<div class="col-sm-9 blog-main">

			<h1>Author profile</h1>

			<?php echo get_avatar( get_the_author_meta( 'ID' ), 72 ); ?>

			<?php if ( have_posts() ) : ?>

				<h1 class="archive-title">
					<?php
					/*
					 * Queue the first post, that way we know what author
					 * we're dealing with (if that is the case).
					 *
					 * We reset this later so we can run the loop properly
					 * with a call to rewind_posts().
					 */
					the_post();

					printf( __( '%s', 'gigasci' ), get_the_author() );
					?>
				</h1>
				<?php if ( get_the_author_meta( 'description' ) ) : ?>
					<div class="author-description"><?php the_author_meta( 'description' ); ?></div>
				<?php endif; ?>

				<?php
				/*
				 * Since we called the_post() above, we need to rewind
				 * the loop back to the beginning that way we can run
				 * the loop properly, in full.
				 */
				rewind_posts();

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