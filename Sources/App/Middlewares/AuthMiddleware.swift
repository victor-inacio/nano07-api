//
//  AuthMiddleware.swift
//
//
//  Created by Daniel Ishida on 26/06/24.
//

import Foundation
import Vapor


final class AuthMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Add your middleware logic here
        print("Request received: \(request)")
        
        // Call the next responder in the chain
        return next.respond(to: request).map { response in
            // Add any response modifications here
            print("Response sent: \(response)")
            return response
        }
    }
}
