// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

contract ProductManagement {
    // Not using create new contract via because we dont want to call complete contract
    //Just to allow ABI calls

    struct part {
        string type_part;
        string serial_num;
        address owner;
        string time_stamp;
    }

    struct product {
        string serial_num;
        string type_prod;
        string time_stamp;
        //assuming that a maximum of 4 parts can build a product, this value is changeable acc to req.
        bytes32[4] parts;
        address owner;
    }

    mapping(bytes32 => part) public parts;
    mapping(bytes32 => product) public products;

    function getParts(bytes32 product_hash)
        public
        returns (bytes32[4] memory)
    {}
}

contract ChangeOwnership {
    enum OpType {PART, PRODUCT}//0 is part, 1 is product
    mapping(bytes32 => address) public CurrentPartOwner;
    mapping(bytes32 => address) public CurrentProductOwner;

    event TransferOwnership_part(bytes32 indexed Part, address indexed owner);
    event TransferOwnership_product(
        bytes32 indexed Part,
        address indexed owner
    );
    ProductManagement private inst_pm;

    constructor(address p_contractadd) public {
        inst_pm = ProductManagement(p_contractadd);
        //this is for chicking product validity
    }

    function CreateOwnership(uint256 optype, bytes32 phash)
        public
        returns (bool)
    {
        if (optype == uint256(OpType.PART)) {
            address owner;
            (, , owner, ) = inst_pm.parts(phash);
            require(
                CurrentPartOwner[phash] == address(0),
                "Part Already Registered"
            );
            require(owner == msg.sender, "Part Wasn't Manufactured By Requester");
            CurrentPartOwner[phash] = msg.sender;
            emit TransferOwnership_part(phash, msg.sender);
        } else if (optype == uint256(OpType.PRODUCT)) {
            address owner;
            (, , , owner) = inst_pm.products(phash);
            require(
                CurrentProductOwner[phash] == address(0),
                "Product Already Registered"
            );
            require(owner == msg.sender, "Product Wasn't Made By Requester");
            CurrentProductOwner[phash] = msg.sender;
            emit TransferOwnership_product(phash, msg.sender);
        }
    }

    function TransferOwnership(
        uint256 optype,
        bytes32 phash,
        address new_owner
    ) public returns (bool) {
        if (optype == uint256(OpType.PART)) {
            require(
                CurrentPartOwner[phash] == msg.sender,
                "Part Ownership is not of requester"
            );
            CurrentPartOwner[phash] = new_owner;
            emit TransferOwnership_part(phash, new_owner);
        } else if (optype == uint256(OpType.PRODUCT)) {
            require(
                CurrentProductOwner[phash] == msg.sender,
                "Product Ownership is not of requester"
            );
            CurrentProductOwner[phash] = new_owner;
            emit TransferOwnership_product(phash, new_owner);
            // BUT THE CHANGE HERE IS WE MUST TRANSFER OWNERSHIP OF PARTS AS WELL
            bytes32[4] memory partslist = inst_pm.getParts(phash);
            uint256 i;
            for (i = 0; i < partslist.length; i++) {
                CurrentPartOwner[partslist[i]] = new_owner;
                //TRAVERSE THROUGH EVERY PART AND CHANGE OWNERSHIP
                emit TransferOwnership_part(partslist[i], msg.sender);
            }
        }
    }
}
