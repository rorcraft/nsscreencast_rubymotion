class ViewController < UIViewController

  def viewDidLoad
    super
    @table = UITableView.alloc.init
    # @table = UITableView.alloc.initWithFrame(CGRectMake(0, 0, 100, 100))
    @table.dataSource = self
    @table.delegate = self
    @table.backgroundColor = UIColor.yellowColor
    # BubbleWrap.rgb_color(96, 95, 90)

    @results = []

    Beer.fetch_beers do |results|
      @results = results
      @table.reloadData
    end

    self.view = @table
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @results.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: nil)
    # cell.textLabel.text = "sample cell"
    # cell

    @cellIdentifier = "cell"
    cell = tableView.dequeueReusableCellWithIdentifier(@cellIdentifier)
    if !cell
       cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @cellIdentifier)
       cell.contentView.backgroundColor = @table.backgroundColor
       cell.textLabel.font = UIFont.boldSystemFontOfSize(14)
       cell.textLabel.textColor = UIColor.darkGrayColor
       cell.textLabel.backgroundColor = cell.contentView.backgroundColor
       # cell.detailTextLabel.backgroundColor = cell.textLabel.backgroundColor

    end
    beer = @results[indexPath.row]
    cell.textLabel.text = beer.text
    cell.imageView.url = {url: beer.image_url.to_url, placeholder: nil}
    cell
  end
end
