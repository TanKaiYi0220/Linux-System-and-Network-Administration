- <h2>Netns</h2>

    -   連到Internet
        - [x] nsA
        `ip netns exec nsA ping 8.8.8.8`
        - [x] nsB
        `ip netns exec nsB ping 8.8.8.8`
        - [ ] nsNYCU
        `ip netns exec nsNYCU ping 8.8.8.8`
        - [ ] nsNTHU
        `ip netns exec nsNTHU ping 8.8.8.8`
        - [ ] nsTHU
        `ip netns exec nsTHU ping 8.8.8.8`

    - nsA/nsB之間可以互相Ping
        - [x] `ip netns exec nsA ping 10.33.55.3`
        - [x] `ip netns exec nsB ping 10.33.55.2`
    <hr style="margin: 10px; height: 1px;">

    - 
        - [ ] DHCP Server發放給A/B達成自動取得IP
    <hr style="margin: 10px; height: 1px;">

    -
        - [x] ns可以Ping往Internet，並且呈現在Traceroute
        `traceroute 8.8.8.8`

- <h2>Firewall</h2>

    - 
        - [ ] 允許103.136.224.1~103.136.224.7的IP SSH連線到主機
    <hr style="margin: 10px;height: 1px;">

    -
        - [ ] 阻擋103.136.224.8~103.136.224.15的IP SSH連線到主機
    <hr style="margin: 10px;height: 1px;">

    -
        - [ ] 阻擋NAPT之下的netns連往特定IP 103.136.225.150
    <hr style="margin: 10px;height: 1px;">

    -
        - [ ] 建立Port Forwarding讓netns內的特定Port服務可以被外網連到
        (設定nsA的8888 Port會對應到host的7777)

- <h2>Demo</h2>

    - 讓其他人無法Ping到你的電腦 
        - [ ] 無回應
        - [ ] 顯示Network unreachable
    <hr style="margin: 10px;height: 1px;">

    -
        - [ ] 利用SNAT的方式在Bridge間的兩個netns改變IP
    <hr style="margin: 10px;height: 1px;">

    -
        - [ ] 建立Log針對nsA連線到的每一個IP紀錄