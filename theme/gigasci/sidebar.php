<div class="col-sm-3 blog-sidebar">
    <div id="twitter_timeline" style="height:400px;">
        <a class="twitter-timeline" data-theme="light"
           data-dnt="true" height="400"
           href="https://twitter.com/gigascience"
           data-widget-id="385649284785266688">Tweets by
            @GigaScience</a>
        <script>!function (d, s, id) {
                var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https';
                if (!d.getElementById(id)) {
                    js = d.createElement(s);
                    js.id = id;
                    js.src = p + "://platform.twitter.com/widgets.js";
                    fjs.parentNode.insertBefore(js, fjs);
                }
            }(document, "script", "twitter-wjs");</script>
    </div>

	<div class="sidebar-module">
        <div class="panel-heading">
            <h3 class="panel-title sidebar-title"><span class="glyphicon glyphicon-envelope"></span> Subscribe to GigaBlog</h3>
        </div>
        <div class="panel-body sidebar-content">
            <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Enter your email">
        </div>

        <div class="panel-heading">
            <h3 class="panel-title sidebar-title"><span class="glyphicon glyphicon-book"></span>  Archive</h3>
        </div>
        <div class="panel-body sidebar-content">
            <?php wp_get_archives( 'format=custom&before=<p class="archive-months">&after=</p>&type=monthly&limit=6' ); ?>
        </div>

        <div class="panel-heading">
            <h3 class="panel-title sidebar-title"><span class="glyphicon glyphicon-tags"></span> Popular tags</h3>
        </div>
        <div class="panel-body">
            <?php the_tags( '<ul class="list-unstyled list-group"><li class="popular-tags">', '</li><li class="sidebar-content">', '</li></ul>' ); ?>
        </div>
    </div>
</div><!-- /.blog-sidebar -->