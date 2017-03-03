<?php
/**
 * The template for displaying 404 pages (Not Found)
 *
 * @package WordPress
 * @subpackage gigasci
 * @since
 */

get_header(); ?>

<div class="row">

	<div class="col-sm-9 blog-main">

		<h1><?php _e( 'Page not found', 'gigasci' ); ?></h1>

		<p><?php _e( 'Sorry, the page you requested is unavailable. The link you requested might be broken, or no longer exists.', 'gigasci' ); ?></p>
		<p><?php _e( 'Maybe try a search or start at our homepage?', 'gigasci' ); ?></p>

	</div> <!-- /.blog-main -->

	<?php get_sidebar(); ?>

</div> <!-- /.row -->

<?php get_footer(); ?>

