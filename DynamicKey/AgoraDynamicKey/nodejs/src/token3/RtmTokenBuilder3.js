const AccessToken = require('./AccessToken3').AccessToken3
const ServiceRtm = require('./AccessToken3').ServiceRtm

/**
 * RtmPermission is the permissions of the corresponding module resources, support extend
 * @resourceKeys the corresponding module
 * @permissionKeys specific permission
 */
const RtmPermission = {
    resourceKeys: {
        kMessageChannels: 0,
        kStreamChannels: 1,
        kGroupChannels: 2,
        kGroupServers: 3,
        kUser: 4
    },
    permissionKeys: {
        kRead: 0,
        kWrite: 1
    }
}

class RtmTokenBuilder {
    /**
     * Build the RTM token.
     *
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @param userId The user's account, max length is 64 Bytes.
     * @param expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @param permissions The permissions, can be string or object.
     * @example
     * const permissions_obj = {
     *     [RtmPermission.resourceKeys.kMessageChannels]: {
     *         [RtmPermission.permissionKeys.kRead]: ['channel_A*', 'channel_B*'],
     *         [RtmPermission.permissionKeys.kWrite]: ['channel_C'],
     *     },
     *     [RtmPermission.resourceKeys.kStreamChannels]: {
     *         [RtmPermission.permissionKeys.kRead]: ['*'],
     *         [RtmPermission.permissionKeys.kWrite]: ['channel_D']
     *     }
     * }
     *
     * const permissions_string = JSON.stringify(permissions_obj)
     * @return The RTM token.
     */
    static buildToken(appId, appCertificate, userId, expire, permissions) {
        let token = new AccessToken(appId, appCertificate, null, expire)
        let permissionsObj = RtmTokenBuilder._genPermissions(permissions)
        const permissionsMap = RtmTokenBuilder._objToMap(permissionsObj)
        let serviceRtm = new ServiceRtm(userId, permissionsMap)
        serviceRtm.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
        token.add_service(serviceRtm)

        return token.build()
    }

    static fromString(token) {
        return new AccessToken().from_string(token)
    }

    /**
     * Convert the object to a map
     * @param {Object} obj
     * @returns {Map}
     */
    static _objToMap(obj) {
        const map = new Map()
        for (let [key, value] of Object.entries(obj)) {
            if (value instanceof Array) {
                map.set(Number(key), value)
            } else if (value !== null && typeof value === 'object') {
                map.set(Number(key), RtmTokenBuilder._objToMap(value))
            } else {
                map.set(Number(key), value)
            }
        }
        return map
    }

    /**
     * Generate permissions
     * @param {Object|String} permissions
     * @returns {Object}
     */
    static _genPermissions(permissions) {
        // set default
        const defaultPermissions = {}

        let finalPermissions = {}
        let customPermissions = {}

        // string or obj to obj
        if (typeof permissions === 'string') {
            try {
                customPermissions = JSON.parse(permissions)
            } catch (err) {
                finalPermissions = defaultPermissions
                console.log(err)
            }
        } else if (typeof permissions === 'object') {
            customPermissions = permissions
        }

        // use custom
        if (Object.keys(customPermissions).length > 0) {
            Object.values(RtmPermission.resourceKeys).forEach(resourceKey => {
                Object.values(RtmPermission.permissionKeys).forEach(permissionKey => {
                     // use custom
                    if (
                        customPermissions?.[resourceKey]?.[permissionKey] &&
                        Array.isArray(customPermissions?.[resourceKey]?.[permissionKey])
                    ) {
                        if (!finalPermissions[resourceKey]) {
                            finalPermissions[resourceKey] = {}
                        }
                        const arr = customPermissions[resourceKey][permissionKey]?.filter(
                            item => typeof item === 'string'
                        )
                        arr?.length > 0 && (finalPermissions[resourceKey][permissionKey] = arr)
                    }
                })
            })
        } else {
            // use default
            finalPermissions = defaultPermissions
        }
        return finalPermissions
    }
}

module.exports.RtmTokenBuilder = RtmTokenBuilder
module.exports.RtmPermission = RtmPermission
