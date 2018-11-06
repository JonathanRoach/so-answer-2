# Stack Overflow Answer 2

This is an answer to Stack Overflow question [here](https://stackoverflow.com/questions/53119375/update-tableview-row-from-appdelegate-swift-4)
where the questioner was asking how to update a cell in a UITableView. This demo shows
how to connect data to UI using ALTableViewHelper available on ![Framework Central](https://frameworkcentral.com/static/home/img/logo-small.png), and
so remove the need for any code to copy the data when it updates.

The main 'engine' is this section:

    tableView.setHelperString("""
    section
        headertext "Conversation Status"
        body
            Conversation
                $.viewWithTag(1).text <~ conversations[conversations.count-1]["title"]
                $.viewWithTag(2).text <~ "At \\(dateFormat.stringFromDate(conversations[conversations.count-1]["update"]))"
            UpdateButton
                $.viewWithTag(1).isAnimating <~ FakeConversationGetter.singleton.busy
    """, context: self)

where the data is connected with the UI. Filling and updating the UITableView is fully handled once the connections are described.

`$` is the view added, and `<~` is the 'connect this to that' operator.

What isn't shown in this example is that sections and section views can be 'multiplied' by the contents of arrays - one section or view for each array member.
