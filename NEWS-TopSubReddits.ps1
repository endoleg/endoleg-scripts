param(
    $SubredditName='powershell',
    $count=10
)

Write-Verbose "Fetching Top $SubredditName subreddits" 

$rawposts = (Invoke-RestMethod "https://www.reddit.com/r/$($SubredditName).json?limit=1000").data.children.data
$redditposts = foreach($post in $rawposts){
    [PSCustomObject] @{
        name  = $post.name
        ups   = $post.ups
        numcomments = $post.num_comments
        author  = $post.author
        #score = $post.score
        flair = $post.link_flair_text
        createdUTC  = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($post.created_utc))
        title = $post.title
        url     = $post.url
    }
}

$redditposts | Where-Object {$_.createdutc -gt (get-date).AddDays(-8)} `
             | Sort-Object ups, numcomments -Descending `
             | Select-Object -First $count 

#forked from Prateek Singh @singhprateik
