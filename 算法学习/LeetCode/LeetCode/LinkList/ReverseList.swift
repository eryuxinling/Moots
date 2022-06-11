//
//  ReverseList.swift
//  LeetCode
//
//  Created by 黄伯驹 on 2021/10/31.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://leetcode-cn.com/problems/reverse-linked-list/submissions/
func reverseList(_ head: ListNode?) -> ListNode? {
    var result: ListNode?
    var head = head

    while head != nil {
        let next = head?.next
        head?.next = result
        result = head
        head = next
    }

    return result
}

class ReverseBetween {
    func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int) -> ListNode? {
        let dummy = ListNode(-1)
        dummy.next = head
        var node: ListNode? = dummy

        for _ in 0 ..< left - 1 {
            node = node?.next
        }
        let firstNode = node
        let midNode = firstNode?.next

        for _ in 0 ... right - left {
            node = node?.next
        }
        let thirdNode = node?.next

        firstNode?.next = nil
        node?.next = nil

        _ = reverseLink(midNode)

        firstNode?.next = node
        midNode?.next = thirdNode

        return dummy.next
    }

    func reverseLink(_ head: ListNode?) -> ListNode? {
        var result: ListNode?
        var node = head
        while node != nil {
            let next = node?.next
            node?.next = result
            result = node
            node = next
        }
        return result
    }
}
